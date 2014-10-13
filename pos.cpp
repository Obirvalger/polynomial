#include <iostream>
#include <vector>
#include <cstring>


using namespace std;

long long int ipow(int base, int exp) {
    long long int result = 1LL;
    while(exp) {
        if (exp & 1LL) {   
            result *= base;
        }
        exp >>= 1;
        base *= base;
    }
    return result;
}

int _log2( unsigned int x ) {
  unsigned int ans = 0, y = x;
  while( x>>=1 ) ans++;
  if((y - ipow(2, ans)) != 0)
  	return -1;
  return ans ;
}

ostream& operator<<(ostream& out, const vector<int>& pol) {
	if (! pol.empty()) {
        for(int i = 0; i < pol.size(); ++i) {
            out<<pol[i]<<' ';
        }
        out<<endl;
    }
	return out;
}

vector<int> make_vector(const char *str) {
    vector<int> data(strlen(str)); 
    for (int i = 0; i < strlen(str); ++i) {
        data[i] = str[i] - '0';
    }
    if (_log2(data.size()) == -1) {
        throw "wrong number of digts";
    }
    return data;
}

vector<int> make_poly(vector<int> data){
    int len = data.size(), j;
    for (int i = 0; i < _log2(len); ++i) {
        j = len - 1;
        while (j > 0) {
            for (int k = 0; k < ipow(2,i); ++k) {
            data[j - k] = (data[j - k] ^ data[j - k - ipow(2,i)]);
            }
            j = j - ipow(2, (i + 1));
        }
    }
    return data;
}

int main(int argc, char **argv) try {
    const char* str = (argc == 1) ? "0" : argv[1];
    cout<<make_poly(make_vector(str));
    return 0;
} catch(const char *s) {
    cout<<1<<endl;
    return 1;
}
