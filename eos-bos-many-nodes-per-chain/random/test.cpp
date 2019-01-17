#include "test.hpp"
#include <eosiolib/transaction.h>
#include <eosiolib/print.hpp>
using namespace eosio;

ACTION test::clear(){
   //require_auth(_self);
   seedobjs table(_self, _self.value);
   auto iter = table.begin();
   while (iter != table.end())
   {
      table.erase(iter);
      iter = table.begin();
   }
}



std::string to_hex( const char* d, uint32_t s )
{
   std::string r;
   const char* to_hex="0123456789abcdef";
   uint8_t* c = (uint8_t*)d;
   for( uint32_t i = 0; i < s; ++i )
      (r += to_hex[(c[i]>>4)]) += to_hex[(c[i] &0x0f)];
   return r;
}

ACTION test::hascontract(const args_name& t){
   bool r = has_contract(t.name_);
   print_f("% has_contract:%", t.name_.to_string().c_str(),r);

   checksum256 code;
   get_contract_code(t.name_, &code);

   std::string s = to_hex((char*)code.data(), 32);
   print_f("% contract_code:%", t.name_.to_string().c_str(),s.c_str());
}

ACTION test::generate(const args& t){
   for (int i = 0; i < t.loop; ++i) {
      checksum256 txid;
      get_transaction_id(&txid);
      std::string tx = to_hex((char*)txid.data(), 32);

      uint64_t seq = 0;
      get_action_sequence(&seq);


      size_t szBuff = sizeof(signature);
      char buf[szBuff];
      memset(buf,0,szBuff);
      size_t size = bpsig_action_time_seed(buf, sizeof(buf));
      eosio_assert(size > 0 && size <= sizeof(buf), "buffer is too small");
      std::string seedstr = to_hex(buf,size);


      seedobjs table(_self, _self.value);
      uint64_t count = 0;
      for (auto itr = table.begin(); itr != table.end(); ++itr) {
         ++count;
      }

      auto r = table.emplace(_self, [&](auto &a) {
          a.id = count + 1;
          a.create = eosio::time_point_sec(now());
          a.seedstr = seedstr;
          a.txid = tx;
          a.action = seq;
      });
      print_f("self:%, loop:%, count:%, seedstr:%", name{_self}.to_string().c_str(), t.loop, count, r->seedstr.c_str());
   }
}

ACTION test::inlineact(const args_inline& t){
   auto& payer = t.payer;
   args gen;
   gen.loop = 1;
   gen.num = 1;

   generate(gen);

   if(t.in.value != 0)
   {
      INLINE_ACTION_SENDER(test, generate)( t.in, {payer,"active"_n},
                                                               { gen});
      INLINE_ACTION_SENDER(test, generate)( t.in, {payer,"active"_n},
                                                               { gen});
   }

}

EOSIO_DISPATCH( test, (generate)(clear)(hascontract)(inlineact) )