Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35584 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdC0ISa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Mar 2017 04:18:30 -0400
Subject: Re: Consider including ef388e2054fe ("xfs: don't allow di_size with
 high bit set") into stable releases
References: <53efcbd6-289e-3b71-3d47-73d2b06b98ba@gmail.com>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <666a6b51-1f2f-d175-6c39-c7475125c045@suse.cz>
Date: Mon, 27 Mar 2017 10:18:18 +0200
MIME-Version: 1.0
In-Reply-To: <53efcbd6-289e-3b71-3d47-73d2b06b98ba@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <n.borisov.lkml@gmail.com>, stable@vger.kernel.org
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org, bfoster@redhat.com

On 03/27/2017, 09:43 AM, Nikolay Borisov wrote:
> Hello,
> 
> 
> The patch in the subject applies cleanly on 4.4 and I have attached the
> backport for 3.12. This causes hangs in both xfs/133 and xfs/134. As is
> customary - a battery of xfstests have been run to ensure no regressions
> were introduced.

Applied to 3.12, thanks!


-- 
js
suse labs
