Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Sep 2006 08:48:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8CFlfif024481
	for <linux-xfs@oss.sgi.com>; Tue, 12 Sep 2006 08:47:42 -0700
Message-ID: <4506D66D.8060206@sandeen.net>
Date: Tue, 12 Sep 2006 10:46:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Mounting IRIX disk on Linux
References: <45053B2D.50203@crc.dk> <4505712E.5070801@oss.sgi.com> <4506529F.9030109@crc.dk> <4506831A.3000001@sgi.com>
In-Reply-To: <4506831A.3000001@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Mogens Kjaer <mk@crc.dk>, linux-xfs@oss.sgi.com

Timothy Shimmin wrote:

>> This gives me:
>>
> 
>> versionnum = 0x1084
> 
> #define XFS_SB_VERSION_DIRV2BIT         0x2000
> 
> So, yes it doesn't look like you have v2 directories
> and there is no support for it in Linux.

Hm, the kernel should probably print something more helpful in that case :)

-Eric
