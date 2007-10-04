Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 14:10:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94LAoJa008193
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 14:10:51 -0700
Message-ID: <470556D6.3090703@sandeen.net>
Date: Thu, 04 Oct 2007 16:10:46 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] XFS bitops to Linux again
References: <200710040027.16926.ak@suse.de>    <60338.192.168.3.1.1191452291.squirrel@mail.aconex.com>    <200710041014.22936.ak@suse.de> <34787.192.168.3.1.1191530551.squirrel@mail.aconex.com>
In-Reply-To: <34787.192.168.3.1.1191530551.squirrel@mail.aconex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: Andi Kleen <ak@suse.de>, xfs@oss.sgi.com

nscott@aconex.com wrote:

> Great.  You're light years ahead of the rest of the cleanup brigade. :)

Hey, I resemble that remark!  :)

(FWIW, I too first ran through xfsqa with both calculations in place,
and caused it to complain loudly if there was a mismatch.  Not 100%
coverage, but I'm not trying to do this half-assed either...)

>> I did also some simple tests using the QA suite -- i believe a few logs
>> were recovered -- but not the full tests.
> 
> From a quick look, tests 085, 086 and 087 are the ones I was thinking of
> yesterday.
> 
>>> To be honest, this sounds like just code churn and risk
>>> introduction.
>> Ok I got the message. I retract the patch. Sorry for bothering you
>> with lowly cleanups.
> 
> Hey, I like cleanup as much as the next guy (as long as the next guy isn't
> Eric,
> he just lives to clean ;)

If I do any real work I might lose my job ;-) </joke>

> - also always ignores userspace despite knowing
> better)

Nah, I just forget.

-Eric
