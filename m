Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 01:30:29 -0700 (PDT)
Received: from mail.charite.de (mail.charite.de [160.45.207.131])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6S8UFDW018821
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 01:30:16 -0700
Received: from localhost (localhost [127.0.0.1])
	by mail.charite.de (Postfix) with ESMTP id F41EF220812
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 10:29:52 +0200 (CEST)
Received: from mail.charite.de ([127.0.0.1])
	by localhost (mail.charite.de [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id eH2n2VPx94-U for <xfs@oss.sgi.com>;
	Fri, 28 Jul 2006 10:29:52 +0200 (CEST)
Received: from postamt.charite.de (postamt.charite.de [160.45.207.132])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mail.charite.de (Postfix) with ESMTP id E64462207E0
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 10:29:51 +0200 (CEST)
Date: Fri, 28 Jul 2006 10:29:50 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
Subject: Re: Problem with xfs_repair
Message-ID: <20060728082950.GA30429@charite.de>
References: <20060728064505.GA14714@charite.de> <200607280656.QAA18277@larry.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200607280656.QAA18277@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Barry Naujok <bnaujok@melbourne.sgi.com>:
 
> You have hit a recent regression that is covered in the FAQ http://oss.sgi.com/projects/xfs/faq.html#dir2

I was only aware of a bug in 2.6.18-rcX (until now). Thanks.
I'm in fact running 2.6.17.7
 
> You have two options:
>   1. Do the steps in the FAQ

Just what I asked for.

>   2. Try the xfs_repair patch I just posted to this list.

This means I'd have to get this running under knoppix (or should I try
an in place repair)?

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universitätsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to spamtrap@charite.de
