Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from synagogue.naos.co.nz ([203.171.38.148]:43862 "EHLO
        synagogue.naos.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935036AbdLSC2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Dec 2017 21:28:40 -0500
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
 <20170927004302.GB3666@dastard>
 <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
 <20170927043308.GC3666@dastard>
 <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
From: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Message-ID: <0dbebe1a-4704-0880-87cc-f029921b6c7f@mcneill.gen.nz>
Date: Tue, 19 Dec 2017 15:19:32 +1300
MIME-Version: 1.0
In-Reply-To: <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hi Dave,

On 28/09/17 12:36, Ewen McNeill wrote:
> Perhaps the perfect is the enemy of the good here.  Would it help if I 
> were to write up some text covering:
> [... storage media/RAID considerations for xfs layout ...]
> 
> (No promises when, but "October" seems plausible if this would be useful.)

So... October proved not to be plausible.  But I'm still considering 
writing something, perhaps while it's quieter over late December/early 
January.

AFAICT the relevant "TODO" section of:

https://git.kernel.org/pub/scm/fs/xfs/xfs-documentation.git/tree/admin/XFS_Performance_Tuning/filesystem_tunables.asciidoc

is unchanged.

If it's still useful to write something, I'll see if there's a quiet 
"home" day over the holidays to write a page or so about the 
considerations I'm aware of as a SysAdmin.

Ewen

