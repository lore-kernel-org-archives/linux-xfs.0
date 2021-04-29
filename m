Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05676C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 17:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A706141E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 17:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241012AbhD2Rwy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Apr 2021 13:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240931AbhD2Rwy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Apr 2021 13:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5AAE6613FF;
        Thu, 29 Apr 2021 17:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619718727;
        bh=timUPoTpAXouMZdauVIrhnWw8EeXjiihj7oHTCRBEGU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=AKbLS0+u2+QZTWhUTkYOD9NIDcpkX5vekB7C3S33QIpBxwORcSv+fgv6d43/hgzgI
         urtPDua9uR8+x+IpKj3mmOPJulSfLtdYpu6q5woxPTYSziYVzimyJ4kwD/1wLH4sV4
         3FLNluPWucUWJ2kO1ATBfGitS62RHRSURJXQ8Hea3xIgSQVfsDwTrUhEyc0Ih73clT
         H8/yym0LiX4ZiZJfil7QY974QvpQYwOi+kyt4ezMz9kOjH2sc3VXqVKYWvfv2cjp4x
         e0yGLZ8LxSRfIYsO6adzgpZ8hBfcscFtR4gmscrKrHeHg/OWjI+hq0C4IrF/oSpREX
         t5S9IzkziYSFA==
Subject: Re: [GIT PULL] xfs: new code for 5.13
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210429170619.GM3122264@magnolia>
References: <20210429170619.GM3122264@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210429170619.GM3122264@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.13-merge-3
X-PR-Tracked-Commit-Id: 76adf92a30f3b92a7f91bb00b28ea80efccd0f01
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d2b6f8a179194de0ffc4886ffc2c4358d86047b8
Message-Id: <161971872723.11214.4279033295206868895.pr-tracker-bot@kernel.org>
Date:   Thu, 29 Apr 2021 17:52:07 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 29 Apr 2021 10:06:19 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.13-merge-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d2b6f8a179194de0ffc4886ffc2c4358d86047b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
