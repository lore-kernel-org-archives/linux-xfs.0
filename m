Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 31 Oct 2007 04:21:25 -0700 (PDT)
Received: from waldorf.loreland.org (uk.loreland.org [89.16.172.112])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9VBLADg030587
	for <xfs@oss.sgi.com>; Wed, 31 Oct 2007 04:21:15 -0700
In-Reply-To: <47267EC7.8000906@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725FBB4.1010400@sandeen.net> <47267EC7.8000906@sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <177CA06B-41D3-4E4A-9EA6-5688C952CD63@loreland.org>
Content-Transfer-Encoding: 7bit
From: James Braid <jamesb@loreland.org>
Subject: Re: Default mount options (that suck less).
Date: Wed, 31 Oct 2007 11:05:09 +0000
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs@oss.sgi.com

On 30 Oct 2007, at 00:45, Timothy Shimmin wrote:
> It might be interesting if people let us know what non-default
> mkfs and mount options that they are using for their various
> configurations/classes.
> Didn't Russell C. have some survey years ago - can't remember if
> that was for h/ware or what now.

We have a ~100TB filesystem that was made with the default mkfs.xfs  
options from memory. The only mount option we use is inode64.
