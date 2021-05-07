Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D761FC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 07:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A814B6143F
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 07:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhEGHwg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 May 2021 03:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230007AbhEGHwg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 May 2021 03:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C113861431;
        Fri,  7 May 2021 07:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620373896;
        bh=v4gRAs2C6EM1QGqwpyvwBhoC32x4EUYsf3hNJVl9MQU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=p/wEDgqC9oH///ia7emQYIgdQlxtKScYWfBJbA1G2fqDX2N2SkdNkc735BdZw/Klb
         UmFOz+zV1gyOGzNCYRoVFhbsI6ci7gaod8f6+s67Kcxp0LyEpkSlF7GS5IQwBi53C2
         5ZAnFS+R2TjgLnNcuv/HubNttAZkFj1vJ8un+ipAdXikRCadP0umH3aull06JDWXKl
         xuPnQ3t2eu+BEwnEf2MAcQE7cSY1ApWUvSvY2sxBiWcJs4yy9FuXtpgnJlT0HFDdQl
         gRJluIx+KZAR784gxRezloEMM5P/i9CaZC5N8lk6N5GK1t3v5NOy9EMIKaHREgnbAV
         JSYMurAUKpvZg==
Subject: Re: [GIT PULL] iomap: one more change for 5.13-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210507003748.GG8582@magnolia>
References: <20210507003748.GG8582@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210507003748.GG8582@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.13-merge-3
X-PR-Tracked-Commit-Id: 6e552494fb90acae005d74ce6a2ee102d965184b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 05da1f643f00ae9aabb8318709e40579789b7c64
Message-Id: <162037389676.26493.15809453894943437236.pr-tracker-bot@kernel.org>
Date:   Fri, 07 May 2021 07:51:36 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 6 May 2021 17:37:48 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.13-merge-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/05da1f643f00ae9aabb8318709e40579789b7c64

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
