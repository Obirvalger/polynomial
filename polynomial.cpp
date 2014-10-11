#include <iostream>
#include <vector>
#include <set>
#include <cmath>

using namespace std;

int ipow(int base, int exp) {
    int result = 1;
    while(exp) {
        if (exp & 1) {   
            result *= base;
        }
        exp >>= 1;
        base *= base;
    }
    return result;
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

bool eq(const vector<int> &a, const vector<int> &b) {
    if (a.size() != b.size()) throw "Bad size in eq!";
    for (int i = 0; i < a.size(); ++i) {
	if ((a[i] == 0) && (b[i] != 0))
	    return false;
    }
    return true;
}

vector<int> masked(const vector<vector<int> > &Ekn, const vector<int> &mask) {
    vector<int> v;
    for (int i = 0; i < Ekn.size(); ++i) {
	if (eq(Ekn[i], mask))
	    v.push_back(i);
    }
    
    return v;
}

int sum(const vector<vector<int> > &Ekn, int k, const vector<int> &val, const vector<int> &a, const vector<int> &f) {
    int prod = 1, sum = 0;
    for (int i = 0; i < val.size(); ++i) {
	prod  = 1;
	for (int j = 0; j < Ekn[i].size(); ++j) {
	    if (a[j]) {
		prod *= pow(Ekn[i][j], k - 1 - a[j]);
	    }
	}
	prod *= f[aconv(Ekn[i], k)]; //изменить число
	sum += prod;
	sum %= k;
    }
    return sum;
}

vector<int> polynomial(const vector<int> &f, const vector<int> &d, int k, int n) {
    //~ int size = pow(k,n);
    vector<int> c(f.size()), a;
    vector<vector<int> > Ekn = make_all_Ekn(k,n);
    //~ for (int i = 0; i < Ekn.size(); ++i) {cout<<Ekn[i];}
    set<int> I;
    
    for (int i = 0; i < Ekn.size(); ++i) {
	//~ a = Ekn[i];
	c[i] = sum(Ekn, k, masked(Ekn, Ekn[i]), Ekn[i], f);
	//~ cout<<"a ="<<conv(i,2,n);
	//~ I = makeI(conv(i,2,n));
	//~ cout << "I = " << I;
	//~ c[i] *= pow(-1, makeI(conv(i,2,n)).size());
    }
    
    
    return c;
}

int main() {
    int k = 2, n = 2;
    vector<int> f = {1,1,0,0}, d = {0,0}, c = polynomial(f,d,k,n);

    cout<<"c = "<<c<<endl;
    
    return 0;
}
