Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:32865 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdC0IRg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:17:36 -0400
Subject: Re: Request for inclusion of 4dfce57db635 ("xfs: fix up
 xfs_swap_extent_forks inline extent handling") in stable
References: <473e7987-03d9-4118-d7e1-11465928f021@gmail.com>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <9e025fd5-9497-0e49-a60c-583f96a9d329@suse.cz>
Date: Mon, 27 Mar 2017 10:17:27 +0200
MIME-Version: 1.0
In-Reply-To: <473e7987-03d9-4118-d7e1-11465928f021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, stable@vger.kernel.org, linux-xfs@vger.kernel.org, bfoster@redhat.com, darrick.wong@oracle.com

On 03/27/2017, 09:31 AM, Nikolay Borisov wrote:
> Hello,
> 
> 
> The commit in the subject was tagged as stable but I guess it got missed
> being included into stable. Without these stable kernels crash on
> xfs/118. I've attached backports for both 3.12 and 4.4 and also ran a
> regtest with xfstest with no regressions showing up.

Applied to 3.12, thanks!


-- 
js
suse labs
