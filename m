Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:49:52 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8Q8njOl004314
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:49:48 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IaSaN-0005sv-00
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 10:49:35 +0200
Date: Wed, 26 Sep 2007 10:49:25 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070926084924.GB30287@p15145560.pureserver.info>
References: <498689.78850.qm@web32907.mail.mud.yahoo.com> <Pine.LNX.4.64.0709251938400.7763@p34.internal.lan> <20070926082322.GA30287@p15145560.pureserver.info> <Pine.LNX.4.64.0709260442070.31289@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709260442070.31289@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Justin Piszcz schrieb:
> What was the command line you used for that output?
> tiobench.. ?

tiobench --numruns 3 --threads 1 --threads 2 --block 4096 --size 20000

--size 20000 because the server has 16 GB RAM.

Ralf
