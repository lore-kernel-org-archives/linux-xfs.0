Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Mar 2007 03:32:47 -0700 (PDT)
Received: from ozlabs.org (ozlabs.org [203.10.76.45])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2UAWd6p000675
	for <xfs@oss.sgi.com>; Fri, 30 Mar 2007 03:32:41 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17932.54606.323431.491736@cargo.ozlabs.ibm.com>
Date: Fri, 30 Mar 2007 19:15:58 +1000
From: Paul Mackerras <paulus@samba.org>
Subject: Re: Interface for the new fallocate() system call
In-Reply-To: <20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
	<20070317111036.GC29931@parisc-linux.org>
	<20070321120425.GA27273@amitarora.in.ibm.com>
	<20070329115126.GB7374@amitarora.in.ibm.com>
	<20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071929.GC8365@osiris.boeblingen.de.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Heiko Carstens writes:

> If possible I'd prefer the six-32-bit-args approach.

It does mean extra unnecessary work for 64-bit platforms, though...

Paul.
