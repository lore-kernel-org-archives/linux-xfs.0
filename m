Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35812 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbcKWHTX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2016 02:19:23 -0500
Subject: Re: [PATCH v2] fideduperange.2: fix the discussion of maximum sizes
References: <20161123044816.GG16807@birch.djwong.org>
 <20161123044941.GB27107@mew>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <5ad80a74-15c6-548c-3de9-757a5ae77de9@gmail.com>
Date: Wed, 23 Nov 2016 08:06:46 +0100
MIME-Version: 1.0
In-Reply-To: <20161123044941.GB27107@mew>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Omar Sandoval <osandov@osandov.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-man@vger.kernel.org

On 11/23/2016 05:49 AM, Omar Sandoval wrote:
> On Tue, Nov 22, 2016 at 08:48:16PM -0800, Darrick J. Wong wrote:
>> Fix the discussion of the limitations on the dest_count and src_length
>> parameters to the fideduperange ioctl to reflect what's actually in the
>> kernel.
>>
>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  man2/ioctl_fideduperange.2 |   20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>>
>> diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
>> index 2112d10..057229d 100644
>> --- a/man2/ioctl_fideduperange.2
>> +++ b/man2/ioctl_fideduperange.2

[...]

> Reviewed-by: Omar Sandoval <osandov@fb.com>

Thanks Omar!

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
