pragma circom 2.0.0;

/*This circuit template checks that c is the multiplication of a and b.*/  

template ZKSnarkCircuit () {  
   // Signal inputs
   signal input A;
   signal input B;
   
   // Signals from gates
   signal X;
   signal Y;

   // Final signal output
   signal output Q;

   // Component gates used to create custom circuit
   component And_Gate = AND();
   component Not_Gate = NOT();
   component Or_Gate = OR();
   
   // Circuit logic
   And_Gate.a <== A;
   And_Gate.b <== B;
   X <== And_Gate.out;

   Not_Gate.in <== B;
   Y <== Not_Gate.out;

   Or_Gate.a <== X;
   Or_Gate.b <== Y;
   Q <== Or_Gate.out;
}

template AND() {
    signal input a;
    signal input b;
    signal output out;

    out <== a*b;
}

template NOT() {
    signal input in;
    signal output out;

    out <== 1 + in - 2*in;
}

template OR() {
    signal input a;
    signal input b;
    signal output out;

    out <== a + b - a*b;
}

component main = ZKSnarkCircuit();
