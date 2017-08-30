Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41109 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbdH3Ho3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 03:44:29 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH 00/42] mkfs: factor the crap out of the code
Date: Wed, 30 Aug 2017 09:44:27 +0200
Message-ID: <2698593.8AP5HHh52X@merkaba>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Dave Chinner - 30.08.17, 09:50:
> Everyone who tries to modify mkfs quickly learns that it is a pile
> of spaghetti, the only difference in opinion is whether it is a
> steaming, cold or rotten pile. This patchset attempts to untangle
> the ball of pasta and turn it into a set of clear, obvious
> operations that lead to a filesystem being formatted correctly.

I am thankful that all the XFS filesystems I created up to now *somehow* 
worked. By pure accident maybe :)

Thanks for the commit description which gave me a quite a bit of hearty 
laughing.

Thanks
-- 
Martin
