Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 21:48:15 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2G4m36p014671
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 21:48:04 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l2G4m0xE022069
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 13:48:01 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.161])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l2G4glMV002727
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 13:42:47 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l2G4glG29817 for xfs@oss.sgi.com; Fri, 16 Mar 2007 13:42:47 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l2G4glO22754 for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 13:42:47 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070316.124254.20301592 for <xfs@oss.sgi.com>
	; Fri, 16 Mar 2007 12:42:54 +0900
Subject: Re: xfsdump buglets
In-reply-to: <1174015536.5051.193.camel@edge>
Message-Id: <20070316134240k-ooizumi@rifu.bsd.tnes.nec.co.jp>
References: <1174015536.5051.193.camel@edge>
Mime-Version: 1.0
From: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Date: Fri, 16 Mar 2007 13:42:40 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com, peterc@gelato.unsw.edu.au
Cc: xfs@oss.sgi.com

Hi Nathan,

Nathan Scott <nscott@aconex.com> wrote:
>Hey Bill,
>
>Got a couple of minor xfsdump problems reported to me, they're probably
>straightforward for someone who knows xfsdump well - here ya go...
>
>cheers.
>
>-------- Forwarded Message --------
>From: Peter Chubb <peterc@gelato.unsw.edu.au>
>Reply-To: Peter Chubb <peterc@gelato.unsw.edu.au>,
>415080@bugs.debian.org
>To: submit@bugs.debian.org
>Subject: Bug#415080: Poor error message from xfsdump for incorrect args
>Date: Fri, 16 Mar 2007 09:47:50 +1100
>
>Package: xfsdump
>Version: 2.2.38-1 
>
>I do:
>	xfsdump -l 0 -p -f afile filesystem
>and get
>	xfsdump: ERROR: -^@ argument missing
>because -p needs a numeric argument.
>
>The message should say -p argument missing.
>--
>Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
>http://www.ertos.nicta.com.au           ERTOS within National ICT Australia

This bug has already been fixed.
See also http://oss.sgi.com/archives/xfs/2007-02/msg00010.html

Cheers.
--
Kouta Ooizumi
NEC Software Tohoku, Ltd.
k-ooizumi@tnes.nec.co.jp
