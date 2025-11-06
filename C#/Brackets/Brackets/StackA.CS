using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Brackets
{
    class StackA<T>
    {
       

        // The Stack
        T[] stack;

        // an index pointer that always point to the stack head
        int head;


        // ctor =  n = Size of Stack
        public StackA(int n)
        {
            head = 0;
            stack = new T[n];
        }


        // return whther the stak is Empty or not
        public bool IsEmpty()
        {
            return (head == 0);
        }


        // Insert to the head of the Stack a value (x) only if not Overflow
        public bool Push(T x)
        {
            if (head == stack.Length)
                return false;           //  Stack Overflow
            stack[head++] = x;
            return true;
        }


        // return an item from the head of the stack (if not empty)
        public T Pop ()
        {
            
                  return stack[--head];   // before fetch the value decrement 1 from head.

            
        }


        public override string ToString()
        {
            if (head == 0)
                return "\nEmpty";

            string s = "Head << ";
            for (int i = head -1 ; i >=0 ; i--)
            {
                s += stack[i]+",";
            }

            return s.Substring(0,s.Length -1);
        }



    }
}
