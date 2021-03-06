#!/usr/bin/perl
# $Id: mknodedecls.pl,v 1.6 2013/02/12 18:56:16 david Exp $

$decls = $incls = '';

open NODES, "find nodes -name \\*.h -print |"
  or die "Could not list node headers";
while (<NODES>) {
  if (m/\ball\.h\b/) { next; }
  chomp;
  $decl = $incl = $_;
  #
  # Handle declaration
  #
  $i = $decl =~ s-(([[:alnum:]]|_)+)/-namespace $1 { -g;
  $decl =~ s-(([[:alnum:]]|_)+?)\.h-class $1; -;
  $decls .= $decl;
  for ($j = 0; $j < $i; $j++) {
    $decls .= "} ";
  }
  $decls .= "\n";
  #
  # Handle include
  #
  $incl =~ s/^/#include "/;
  $incl =~ s/$/"/;
  $incls .= "$incl\n";
}
close NODES;

# "nodes" (dir) in $decls should be "node" (namespace)
$decls =~ s/\bnodes\b/node/g;
chomp $decls;

###########################################################################
###########################################################################
###########################################################################
#
# File "nodes/all.h" will now be produced.
#
print<<__EOF__;
//
// **** AUTOMATICALLY GENERATED BY mknodedecls.pl -- DO NOT EDIT ****
//
#ifdef __NODE_DECLARATIONS_ONLY__

//---------------------------------------------------------------------------
//     THESE ARE PREDEFINED NODES, AVAILABLE FROM THE CDK
//---------------------------------------------------------------------------

namespace cdk {
  namespace node {
    class Node;  class Nil;  class Data;  class Composite;  class Sequence;
    namespace expression {
      template <class T> class Simple;
      class Double;  class Integer;  class String;  class Identifier;
      class UnaryExpression;
      class NEG;
      class BinaryExpression;
      class ADD;  class SUB;  class MUL;  class DIV;  class MOD;
      class LT;   class LE;   class GE;   class GT;   class EQ;   class NE;
    }
  } // namespace node
} // namespace cdk

//---------------------------------------------------------------------------
//     THESE ARE THE NODES DEFINED SPECIFICALLY FOR THIS APPLICATION
//---------------------------------------------------------------------------

namespace pf2asm {
$decls
}

//---------------------------------------------------------------------------
//     A L I A S E S
//---------------------------------------------------------------------------

// make sure the "semantics" namespace is known
namespace pf2asm { namespace semantics {} }

namespace vs   = pf2asm::semantics;
namespace vnfu = pf2asm::node::function;

#else /* !defined(__NODE_DECLARATIONS_ONLY__) */

#ifndef __AUTOMATIC_NODE_ALLNODES_H__
#define __AUTOMATIC_NODE_ALLNODES_H__

//---------------------------------------------------------------------------
//     THESE ARE PREDEFINED NODES, AVAILABLE FROM THE CDK
//---------------------------------------------------------------------------

#include <cdk/nodes/Node.h>
#include <cdk/nodes/Data.h>
#include <cdk/nodes/Nil.h>
#include <cdk/nodes/Composite.h>
#include <cdk/nodes/Sequence.h>

#include <cdk/nodes/expressions/Integer.h>
#include <cdk/nodes/expressions/Double.h>
#include <cdk/nodes/expressions/String.h>
#include <cdk/nodes/expressions/Identifier.h>
#include <cdk/nodes/expressions/NEG.h>
#include <cdk/nodes/expressions/ADD.h>
#include <cdk/nodes/expressions/SUB.h>
#include <cdk/nodes/expressions/MUL.h>
#include <cdk/nodes/expressions/DIV.h>
#include <cdk/nodes/expressions/MOD.h>
#include <cdk/nodes/expressions/LT.h>
#include <cdk/nodes/expressions/GT.h>
#include <cdk/nodes/expressions/GE.h>
#include <cdk/nodes/expressions/LE.h>
#include <cdk/nodes/expressions/NE.h>
#include <cdk/nodes/expressions/EQ.h>

//---------------------------------------------------------------------------
//     THESE ARE THE NODES DEFINED SPECIFICALLY FOR THIS APPLICATION
//---------------------------------------------------------------------------

$incls

//---------------------------------------------------------------------------
//     A L I A S E S
//---------------------------------------------------------------------------

// make sure the "semantics" namespace is known
namespace pf2asm { namespace semantics {} }

namespace vs   = pf2asm::semantics;
namespace vnfu = pf2asm::node::function;

//---------------------------------------------------------------------------
//     T H E    E N D
//---------------------------------------------------------------------------

#endif /* !defined(__AUTOMATIC_NODE_ALLNODES_H__) */

#endif /* !defined(__NODE_DECLARATIONS_ONLY__) */
__EOF__

###########################################################################
###########################################################################
###########################################################################

0;

###########################################################################
###########################################################################
###########################################################################
#
# $Log: mknodedecls.pl,v $
# Revision 1.6  2013/02/12 18:56:16  david
# Major code cleanup and simplification. Uses CDK8. C++11 is required.
#
# Revision 1.5  2009/02/28 21:01:06  david
# Minor cleanup.
#
# Revision 1.4  2009/02/25 07:31:53  david
# First working version of pf2asm. This version still uses
# byacc.
#
# Revision 1.3  2009/02/23 20:53:38  david
# First PF implementation. Does not work with PF syntax nor
# does it do anything useful.
#
