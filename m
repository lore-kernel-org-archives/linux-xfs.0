Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 22:05:53 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2G55m6p016941
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 22:05:49 -0700
Subject: Re: xfsdump buglets
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070316134240k-ooizumi@rifu.bsd.tnes.nec.co.jp>
References: <1174015536.5051.193.camel@edge>
	 <20070316134240k-ooizumi@rifu.bsd.tnes.nec.co.jp>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 16:05:42 +1100
Message-Id: <1174021542.5051.196.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Cc: peterc@gelato.unsw.edu.au, xfs@oss.sgi.com

On Fri, 2007-03-16 at 13:42 +0900, Kouta Ooizumi wrote:
> Hi Nathan,
> ...
> >	xfsdump: ERROR: -^@ argument missing
> >because -p needs a numeric argument.
> >
> >The message should say -p argument missing.
> ...
> This bug has already been fixed.
> See also http://oss.sgi.com/archives/xfs/2007-02/msg00010.html

Ah, great - thanks for that.  Ever seen the second problem reported
there before (the wierd absolute vs relative pathname thing)?

cheers.

-- 
Nathan
