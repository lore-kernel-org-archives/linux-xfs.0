Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A269C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 19:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F7564F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 19:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhCRTmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:42:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhCRTmL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 15:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 26BDF64F1D;
        Thu, 18 Mar 2021 19:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616096531;
        bh=7eWdVQYUmGlVxih5fJIMlpuooGliGgydi0lMKmSe+5Q=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=focbUMHBfbFAmiO/3+uZOuMrQYQzj27MNERG0lZycWr2znBQVeq7vrF1mnCcOD+fT
         rA96rV3ajOm6bKTPRGrRormIFJ/2fTY1CWPiyYsOyuDojqEmk8HiswSoWyncdoXJNf
         GGZ3Te7e/qpn4PSDV6u3cl6UZ9+Ze0fZtOYwPDKayyzWSJ9LlAv7jhr350sGrcQB0n
         zWkgQmbpp8Mi8lS/kym/hvKNJqs44yV8/J1WGgIIUodlTNEVROxEUM+Yz58s5rPRui
         dpD+woZeeHmZzw0E6Dk8PyZchLtN9e62tYJ8oVuX1+qlQtIi9nDaHYlETGpLvZLIc5
         738gmmNFEHOtQ==
Subject: Re: [GIT PULL] xfs: fixes for 5.12-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210318191436.GL22100@magnolia>
References: <20210318191436.GL22100@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210318191436.GL22100@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.12-fixes-3
X-PR-Tracked-Commit-Id: 8723d5ba8bdae1c41be7a6fc8469dc9aa551e7d0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c73891c922f5934b826fe5eb743fbdb28aee3f99
Message-Id: <161609653113.4441.2474187984850625994.pr-tracker-bot@kernel.org>
Date:   Thu, 18 Mar 2021 19:42:11 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 18 Mar 2021 12:14:36 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.12-fixes-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c73891c922f5934b826fe5eb743fbdb28aee3f99

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
