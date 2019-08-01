Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:49263 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfHALBI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 07:01:08 -0400
Subject: Re: [PATCH] fs: xfs: xfs_log: Don't use KM_MAYFAIL at
 xfs_log_reserve().
References: <20190729215657.GI7777@dread.disaster.area>
 <1564653995-9004-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
 <20190801105629.GA60054@bfoster>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <f588863e-4951-ddf9-e972-87daa4931231@i-love.sakura.ne.jp>
Date: Thu, 1 Aug 2019 20:00:51 +0900
MIME-Version: 1.0
In-Reply-To: <20190801105629.GA60054@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On 2019/08/01 19:56, Brian Foster wrote:
> I assume this survived your test scenario?

Yes.

> 
> If so, the change looks fine to me. Thanks for the patch.
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
