Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 15:31:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k85MVODW021811
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 15:31:35 -0700
Date: Wed, 6 Sep 2006 08:30:28 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: Kernel Ooops
Message-ID: <20060906083028.I3365803@wobbly.melbourne.sgi.com>
References: <2260b150609050427p3123cb85q5af484d8b907e6ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2260b150609050427p3123cb85q5af484d8b907e6ac@mail.gmail.com>; from seufert@gmail.com on Tue, Sep 05, 2006 at 09:27:04PM +1000
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Seufert <seufert@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 05, 2006 at 09:27:04PM +1000, Chris Seufert wrote:
> I have had this one before, and i had assumed it had been fixed.
> 
> System seems very stable running ext3, so i dont 'think' its hardware
> related, but i am begining to wonder.

This is fixed, what kernel version are you using?  (it was fixed
in -rc5/6 IIRC).

> RIP  [<ffffffff8031dd16>] xfs_btree_init_cursor+0x48/0x1bd

cheers.

-- 
Nathan
