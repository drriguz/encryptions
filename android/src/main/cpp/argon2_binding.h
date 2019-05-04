#ifndef _ARGON2_BINDING_H_
#define _ARGON2_BINDING_H_

#include <argon2.h>
#include <iostream>
#include <string>

using namespace std;


class Argon2
{
public:
    Argon2(uint32_t t, uint32_t m, uint32_t p, uint32_t l)
            : _iterations(t)
            , _memory(m)
            , _parallelism(p)
            , _hashLength(l)
    {
        this->_hash = new uint8_t[l];
    }
    ~Argon2()
    {
        if(_hash)
            delete _hash;
    }
public:
    uint8_t* argon2i(const std::string& pwd, const string& salt) const{
        uint32_t cost = (1 << _memory);
        argon2i_hash_raw(_iterations, cost, _parallelism, pwd.c_str(), pwd.length(), salt.c_str(), salt.length(), _hash, _hashLength);
        return _hash;
    }

    uint8_t* argon2d(const std::string& pwd, const string& salt) const{
        uint32_t cost = (1 << _memory);
        argon2d_hash_raw(_iterations, cost, _parallelism, pwd.c_str(), pwd.length(), salt.c_str(), salt.length(), _hash, _hashLength);
        return _hash;
    }

private:
    uint32_t _iterations;
    uint32_t _memory;
    uint32_t _parallelism;
    uint32_t _hashLength;
    uint8_t* _hash;
};

#endif