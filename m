Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55F3C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 02:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDA161247
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Sep 2021 02:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhI1Cgy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:50978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238598AbhI1Cgy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Sep 2021 22:36:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7255561156
        for <linux-xfs@vger.kernel.org>; Tue, 28 Sep 2021 02:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632796515;
        bh=z8X6MJMe8x20QKOWVpqBTA4zJ2wPyHjW2lnL3PGQX1c=;
        h=Date:From:To:Subject:From;
        b=TAoZx1BP4nbzKzXjgORmq5b45dcnoC/0NJGPxiw0vxWCBzym2XcEgGTcuDxzzOoUg
         6vWSJxxiR4qOMPzqgx3K6pdvx+8BXfkYucnP4iPzgm4qqFnBVopdaEkjqgVuWf1X3h
         Bcy+0LTW7w3k0wEIfyzR7e9/L09sMGsnikGsSya3skTnn+a0uhohk24zVjLDOQwHkv
         ZG77dF8JjcHAHD+8ljfzI2RGqagW87f+rHbiL6UWC5IZDnzMJ3oOfl9B9MHmt5MC5k
         Th9yGgfBs33sMqJ3jdhGiYnkSb+XTR1LGgKgESaaeYVMVGBBOwTsN3pOtwNJzHxjxD
         JK56iV6+FxkQQ==
Date:   Mon, 27 Sep 2021 19:35:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: /me taps out
Message-ID: <20210928023515.GH570642@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Between this and last week's conference and meeting activities, I have
experienced so much pressure and stress dealing with discussions that
never seem to resolve, preparing for customer meetings where people
complain about why can't I get things moving faster, and feeling under
the gun to squeeze patches onto the list in between everything else
going on to try to keep other people unblocked (hence the RFC-for-people
patchsets last week) that I've turned into That Jerk on IRC.

I apologize for being the roaring jerk to people and am putting myself
on timeout until at least next Tuesday the 5th.  I hope this will ease
off by then, because I need to stop working successive 12 hour days.

--D
