Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 11 Apr 2007 00:37:04 -0700 (PDT)
Received: from mail.gatrixx.com (mail.gatrixx.com [217.111.11.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3B7axfB024064
	for <xfs@oss.sgi.com>; Wed, 11 Apr 2007 00:37:01 -0700
Message-ID: <461C9014.6040109@j-o-a.de>
Date: Wed, 11 Apr 2007 09:36:52 +0200
From: Oliver Joa <oliver@j-o-a.de>
MIME-Version: 1.0
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com>
In-Reply-To: <20070328113141.GQ32597093@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: linux-kernel@vger.kernel.org

Hi,

David Chinner wrote:
> On Tue, Mar 27, 2007 at 06:16:04PM +0200, Oliver Joa wrote:
>> Hi,
>>
>> since some weeks i try to get my new hardware running:
>>
>> Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
>> Intel DP965LT Mainboard
>> Seagate SATA-Harddisk in AHCI-Mode
>>
>> After some hours of running or after some heavy file-i/o
>> (find / | cpio -padm /test) I always get a corrupted
>> XFS-filesystem.

I solved the problem: I made a memtest and found a lot of memory-errors, 
then i bought a other brand of memory and everything working fine. The 
first memory i used was brandnew. I bought it together with the board 
and processor. It was from Kingston. Now i have one from Crucial, which 
seems to work fine.

Thanks to everyone for the help

Olli
