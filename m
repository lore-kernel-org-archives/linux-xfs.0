Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9352C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 07:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A51F61432
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 07:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhEGHwg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 May 2021 03:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhEGHwg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 May 2021 03:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A3B956142D;
        Fri,  7 May 2021 07:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620373896;
        bh=L1b//wzCAaqR+ZiUyqrchEVNRjM7avOj6aEkhyDIfC4=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AlB1vZljzYz+JPGdwDJChLE61ivFIcE80i6oEJ9x7+EZD7vcXjhAqDH9rV+AXBorh
         +V1u3ANU5ytPoUSilQaZzmEug8dvS+Aqh09RoQlDQwmt5kNIpcXKvAbHbrS39MTUcV
         hdOEUcNPZuKvlwlyqQKxy6k9HJ7Uyu0gtUeWItNjap1rftEujGg8nC1bhWaJeJ8Mvh
         LvBGdMxMC3dms9IuBNxBAjz4wnJNzs/bCYe9J6lEWyzHTiXNEdEQyyQbcIIn4RL0Ke
         HzcYt3dUDVviiqWOq/36w2CM3tZUrS6GbH1t+5T0izibOvdG/ytUJXmcur9Fc2hYGj
         8QwJgIStqROHQ==
Subject: Re: [GIT PULL] xfs: more new code for 5.13
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210507003244.GF8582@magnolia>
References: <20210507003244.GF8582@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210507003244.GF8582@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.13-merge-5
X-PR-Tracked-Commit-Id: 8e9800f9f2b89e1efe2a5993361fae4d618a6c26
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: af120709b1fb7227f18653a95c457b36d8a5e4d8
Message-Id: <162037389652.26493.11092818693927608843.pr-tracker-bot@kernel.org>
Date:   Fri, 07 May 2021 07:51:36 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 6 May 2021 17:32:44 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.13-merge-5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/af120709b1fb7227f18653a95c457b36d8a5e4d8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
