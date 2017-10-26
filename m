Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49739 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751489AbdJZWcQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 18:32:16 -0400
Subject: Re: [PATCH 00/10] xfsprogs: 4.14 rollup
References: <150905608689.28563.9670731739870415773.stgit@magnolia>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <f4e9491e-fa63-6fc9-27bd-5ed40de75e07@suse.de>
Date: Thu, 26 Oct 2017 17:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <150905608689.28563.9670731739870415773.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 10/26/2017 05:14 PM, Darrick J. Wong wrote:
> Hi all,
> 
> Here is a rollup of everything I still have queued for xfsprogs 4.14.
> This rollup supersedes all the previous xfsprogs patches I've sent,
> though the first three patches in this series haven't changed since
> then.


Any idea when the xfs_io patches for RWF_NOWAIT and write-once I/O will
be incorporated? There are a couple of tests waiting for it.

https://patchwork.kernel.org/patch/9995815/
https://patchwork.kernel.org/patch/9995811/
https://patchwork.kernel.org/patch/9995811/


-- 
Goldwyn
