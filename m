Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 06:11:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94DBEgt024255
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 06:11:17 -0700
Message-ID: <4704E671.40105@sandeen.net>
Date: Thu, 04 Oct 2007 08:11:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS bitops to Linux again
References: <200710040027.16926.ak@suse.de> <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com> <200710041014.22936.ak@suse.de>
In-Reply-To: <200710041014.22936.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: nscott@aconex.com, xfs@oss.sgi.com

Andi Kleen wrote:

>> To be honest, this sounds like just code churn and risk 
>> introduction.
> 
> Ok I got the message. I retract the patch. Sorry for bothering you
> with lowly cleanups.
> 
> -Andi

Hrmph.  I liked it.  Every change has risk but why bother duplicating
existing kernel infrastructure?  Compared to everything else going on
lately this hardly seems worth NAKing.  (though I'm sure the same
complaint/warning/caution could be leveled at the other boatload of
changes in the past month).

-Eric
