Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD9FC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 20:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 970F264E56
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Feb 2021 20:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhB1UO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Feb 2021 15:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231282AbhB1UO5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 28 Feb 2021 15:14:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C1EE64E85;
        Sun, 28 Feb 2021 20:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614543256;
        bh=UHCjfBsgMssuzREO5YJJsNWidYK5vRxkRW6DSu9RgWo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=mE/kCwKe90oGkGAy3h4zivg7DmpYUT7v2Pc5pe0+kXd1fKNsB8BXsuXHD+izsOczf
         dD/X7RJrulPjT27t7fI6kLVJ+FOAEU96FkykBlMFiim7CcpRWifs3YBuD40EITT4i3
         tAubSOPJUDXlkGgfyJ39Px8nY+PIBARUwEkVlpBG+eB+OkYuCATxT82Mei1mV25NxC
         2Fc9jqwcoRFyU5OYpq3De0sLT4NilZrpXxBgbZtEEFB1mtdTCBapKd6+md/o/1rd1n
         2v9iKlmMgQQURRQSkD+69o6hqLQk7kgwB/RMaenpzwaC3v4yQwisR4SgK+ydrYb9kH
         R6QYwNCh9cPcQ==
Subject: Re: [GIT PULL] xfs: fixes for 5.12-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210227173725.GE7272@magnolia>
References: <20210227173725.GE7272@magnolia>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210227173725.GE7272@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.12-merge-6
X-PR-Tracked-Commit-Id: 756b1c343333a5aefcc26b0409f3fd16f72281bf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 03dc748bf11051df1f65a2cb6e317d88934d8960
Message-Id: <161454325648.2182.2660010480088666972.pr-tracker-bot@kernel.org>
Date:   Sun, 28 Feb 2021 20:14:16 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, djwong@kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 27 Feb 2021 09:37:25 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.12-merge-6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/03dc748bf11051df1f65a2cb6e317d88934d8960

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
