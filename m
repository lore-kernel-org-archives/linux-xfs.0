Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF05C432BE
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 19:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 231EB61078
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Aug 2021 19:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbhHAT2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Aug 2021 15:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhHAT2i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 1 Aug 2021 15:28:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7326460234;
        Sun,  1 Aug 2021 19:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627846110;
        bh=gMD3M8FBGT+jCZ5xeSC0cLoBN4JBtQKeWJnyfL4VFik=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Lf7yjpTnc1hMfkKcQwq8sCw0NYx5a2hF1SuCq5bfv6teqYCeSIVZzc1ZalGwpq2S3
         oKOYwx7dw451J0h1QS3vm5GZcLetNhVT9dk4hFjxcdIQkBjtJ/aOjxCFAKhHvS6EkN
         lLrx0RJDtaBNT7+nHJtzSqEQsY//kZ48HN+6vi7FfT86tLoLgsdl6r/WPI+w4pIHrL
         X9qmYcWhwjHww2ST2M9zqvKD7OrMJdP+OD/YFUqHPb201IsqZZnaAyj1085LFMDaay
         VNCce56EiEXIFZdVSISbsE3efRTgHei7c0Nf5J0J2apQ+jfgf+0QltiBSSllfvewG6
         enoiCW7KzG/kw==
Subject: Re: [GIT PULL] xfs: bug fixes for 5.14-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210731213740.GN3601443@magnolia>
References: <20210731213740.GN3601443@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210731213740.GN3601443@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.14-fixes-2
X-PR-Tracked-Commit-Id: 81a448d7b0668ae39c08e6f34a54cc7eafb844f1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aa6603266cc0760ebb83cf11cb5a2b8fca84cd68
Message-Id: <162784611031.1186.18214929758593020802.pr-tracker-bot@kernel.org>
Date:   Sun, 01 Aug 2021 19:28:30 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 31 Jul 2021 14:37:40 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.14-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aa6603266cc0760ebb83cf11cb5a2b8fca84cd68

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
