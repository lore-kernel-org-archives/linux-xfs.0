Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 07:33:58 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9AEXjww005798
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 07:33:48 -0700
Date: Wed, 10 Oct 2007 16:33:38 +0200
From: Louis-David Mitterrand <vindex+lists-xfs@apartia.org>
Subject: running xfs_repair on large partitions
Message-ID: <20071010143337.GA2815@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hello,

1) it would be nice to have a way to know xfs_repair's version (-V ?), 
when using it from a rescue disk I'm never sure if I should get a newer 
one.

2) on a 32bit system, using xfsprogs version 2.9.0 , it seems xfs_repair 
will fail if its process exceeds 4G. Is that right? Is there a way to 
circumvent that limitation?

Thanks,
