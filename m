Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36494 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751523AbdJ0ABY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 20:01:24 -0400
Subject: Re: [PATCH 00/10] xfsprogs: 4.14 rollup
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
 <f4e9491e-fa63-6fc9-27bd-5ed40de75e07@suse.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2180321c-a744-e544-8b44-553117cd2305@sandeen.net>
Date: Thu, 26 Oct 2017 19:01:22 -0500
MIME-Version: 1.0
In-Reply-To: <f4e9491e-fa63-6fc9-27bd-5ed40de75e07@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 10/26/17 5:32 PM, Goldwyn Rodrigues wrote:
> 
> 
> On 10/26/2017 05:14 PM, Darrick J. Wong wrote:
>> Hi all,
>>
>> Here is a rollup of everything I still have queued for xfsprogs 4.14.
>> This rollup supersedes all the previous xfsprogs patches I've sent,
>> though the first three patches in this series haven't changed since
>> then.
> 
> 
> Any idea when the xfs_io patches for RWF_NOWAIT and write-once I/O will
> be incorporated? There are a couple of tests waiting for it.
> 
> https://patchwork.kernel.org/patch/9995815/
> https://patchwork.kernel.org/patch/9995811/
> https://patchwork.kernel.org/patch/9995811/

https://patchwork.kernel.org/patch/9995813/

Apologies, i've been juggling too many things and xfsprogs has been
on the back burner for too long.  Looks like these all have reviews,
I can pull them in for the 4.14 release.

Thanks,
-Eric
