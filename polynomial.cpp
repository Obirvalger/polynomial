#include <iostream>
#include <vector>
#include <set>
#include <cmath>
#include <cstring>
#include <cstdio>
#include <cstdlib>

using namespace std;

int ipow(int base, int exp, int k = -1) {
    int result = 1;
    if (k > 0) base %= k;
    while(exp) {
        if (exp & 1) {
            result *= base;
	    if (k > 0) result %= k;
        }
        exp >>= 1;
        base *= base;
	if (k > 0) base %= k;
    }
    return result;
}

int _log(int k, unsigned int x) {
  unsigned int ans = 0, y = x;
  while(x /= k) ans++;
  if((y - ipow(k, ans)) != 0) {
  	return -1;
	//~ throw "Bad!";
    }
  return ans ;
}

vector<int> make_vector(const char *str) {
    vector<int> data(strlen(str));
    for (int i = 0; i < strlen(str); ++i) {
        data[i] = str[i] - '0';
    }
    return data;
}

ostream& operator<<(ostream& out, const vector<int>& p) {
    for(int i = 0; i < p.size(); ++i) {
	out << p[i] << ' ';
    }
    out << endl;
    return out;
}

ostream& operator<<(ostream& out, const set<int>& p) {
    out << "{";
    for (std::set<int>::iterator it=p.begin(); it!= p.end(); ++it) {
	if (it != p.begin())
	    out << ',' << *it;
	else
	    out << *it;
    }
    out << "}" << endl;
    return out;
}

bool operator<=(const set<int> &a, const set<int> &b) {
    if (a.empty()) return true;
    for (std::set<int>::iterator it=a.begin(); it!= a.end(); ++it) {
	if (b.find(*it) == b.end())
	    return false;
    }
    return true;
}

vector<int> conv(int number, int base, int size) {
  //~ int digits[] = {0,1,2,3,4,5,6,7,8,9};
  vector<int> ret(size,0);
  int i = 0;
  do {
    ret[size - 1 - i++] = number % base;
    number = int(number / base);
  } while (number);

  return ret;
}

int aconv(vector<int> number, int base) {
    int ret = 0;
    int size = number.size() - 1;
    for (int i = 0; i < number.size(); ++i) {
	if (number[i])
	    ret += number[i] * ipow(base, size - i);
    }

    return ret;
}

set<int> makeI(const vector<int> &a) {
    set<int> I;

    for (int i = 0; i < a.size(); ++i) {
	if (a[i]) {
	    I.insert(i + 1);
	}

    }

    return I;
}

vector<vector<int> > make_all_Ekn(int k, int n) {
    vector<vector<int> > v(pow(k,n));
    for (int i = 0; i < v.size(); ++i) {
	v[i] = conv(i,k,n);
    }

    return v;
}

bool le(const vector<int> &a, const vector<int> &b) {
    if (a.size() != b.size()) throw "Bad size in eq!";
    for (int i = 0; i < a.size(); ++i) {
	if ((a[i] != 0) && (b[i] == 0))
	    return false;
    }
    return true;
}

vector<int> masked(const vector<vector<int> > &Ekn, const vector<int> &mask) {
    vector<int> v;
    //~ cout<<"mask = "<<mask;
    for (int i = 0; i < Ekn.size(); ++i) {
	if (le(Ekn[i], mask))
	    v.push_back(i);
    }
    //~ cout<<"Ekn\n";
    //~ for (int i = 0; i < Ekn.size(); ++i) {cout<<Ekn[i];}
    //~ cout<<"v = "<<v;
    return v;
}

int sum(const vector<vector<int> > &Ekn, int k, const vector<int> &val, const vector<int> &a, const vector<int> &f) {
    int prod = 1, sum = 0;
    //~ cout<<f;
    for (int i = 0; i < val.size(); ++i) {
	prod  = 1;
	for (int j = 0; j < a.size(); ++j) {
	    if (a[j]) {
		prod *= ipow(Ekn[val[i]][j], k - 1 - a[j], k);
		prod %= k;
	    }
	    /*if (prod < 0) {
		cout<<"j = "<<j;
		throw "";
	    }*/
	}
	if (prod < 0) {
	    cout<<"ipb = "<<i;
	    throw "";
	}
	prod *= f[aconv(Ekn[val[i]], k)];
	if (prod < 0) {
	    cout<<"ipa = "<<i<<" f[.] = "<<f[aconv(Ekn[val[i]], k)]<<" p = "<<prod;
	    throw "";
	}
	sum += prod;
	sum %= k;
	/*if (sum < 0) {
	    cout<<"is = "<<i;
	    throw "";
	}*/
    }

    return sum;
}

//changing f(x1,x2,...,xn) to f(x1+d1,x2+d2,...,xn+dn)
vector<int> polarize(const vector<int> &f, const vector<int> &d, int k) {
    vector<int> v(f.size()), tmp;
    int j;
    for (int i = 0; i < f.size(); ++i) {
	tmp = conv(i, k, d.size());
	for (int l = 0; l < tmp.size(); ++l) {
	    tmp[l] += (k - d[l]);
	    tmp[l] %= k;
	}
	j = aconv(tmp, k);
	v[j] = f[i];
	/*if (v[j] < 0) {
	    cout<<"j = "<<j;
	    throw "";
	}*/
    }

    //~ cout<<"v = "<<v;
    return v;
}

vector<int> polynomial(vector<int> f, const vector<int> &d, int k, int n) {
    if (n == -1) throw "1err";
    if (d.size() != n) throw "2err";
    vector<int> c(f.size()), a;
    vector<vector<int> > Ekn = make_all_Ekn(k,n);
    f = polarize(f,d,k);
    bool number_non_zeros = false;
    //~ for (int i = 0; i < Ekn.size(); ++i) {cout<<Ekn[i];}
    set<int> I;

    for (int i = 0; i < Ekn.size(); ++i) {
	//~ a = Ekn[i];
	c[i] = sum(Ekn, k, masked(Ekn, Ekn[i]), Ekn[i], f);
	//~ if (c[i] < 0) throw "Bada!";
	number_non_zeros = false;
	for (int j = 0; j < Ekn[i].size(); ++j) {
	    if (Ekn[i][j]) number_non_zeros ^= 1;
	}
	if (number_non_zeros) {
	    c[i] *= -1;
	    c[i] = (c[i] >= 0)? c[i] % k : k + c[i] % k;
	}
	//~ cout<<string(sprintf("%d", i));
	//~ if (c[i] < 0) throw "Badb!";
    }

    return c;
}

int main(int argc, char **argv) try {
    if (argc > 3) {
	vector<int> f = make_vector(argv[1]);
	int k = atoi(argv[2]), n = _log(k, f.size());
	vector<int> d = make_vector(argv[3]), p = polynomial(f,d,k,n);
	cout<<p;
    } else {
	printf("Need 3 arguments, passed %d\n", argc - 1);
    }
    return 0;
} catch(const char *err) {
    printf("%s\n", err);
    return 1;
}
