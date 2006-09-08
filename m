Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Sep 2006 11:30:54 -0700 (PDT)
Received: from amsfep11-int.chello.nl (amsfep17-int.chello.nl [213.46.243.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k88IUfDW003607
	for <xfs@oss.sgi.com>; Fri, 8 Sep 2006 11:30:42 -0700
Received: from cable-213-132-154-40.upc.chello.be ([213.132.154.40])
          by amsfep11-int.chello.nl
          (InterMail vM.6.01.05.04 201-2131-123-105-20051025) with ESMTP
          id <20060908172214.XVNB14551.amsfep11-int.chello.nl@cable-213-132-154-40.upc.chello.be>
          for <xfs@oss.sgi.com>; Fri, 8 Sep 2006 19:22:14 +0200
From: Grozdan Nikolov <microchip@chello.be>
Subject: XFS questions
Date: Fri, 8 Sep 2006 19:23:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200609081923.08215.microchip@chello.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have a few questions regarding the data integrity on XFS filesystems. I have 
4 servers here all running on XFS partitions and I'm a bit concerned about 
the data integrity of an XFS filesystem. After reading a lot of 
benchmarks/user experiences I came to the conclusion that XFS is really very 
fast, as I experience it here on my servers  too, but when it comes to data 
integrity it is wise not to use XFS for partitions containing important files 
as XFS may not be able to recover them after a lets say power outage. I'm 
also worried about the 'zeroing' thing in XFS. 

I have 3 questions... 

1) How reliable is XFS at data-integrity?
2) Will the 'zeroing' thing be removed/fixed in the near future?
3) Will XFS ever support ordered or journalled mode like ReiserFS or Ext3?

Thanks in advance and best regards,

Grozdan
