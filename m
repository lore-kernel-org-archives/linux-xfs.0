Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49760 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfGAPgK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jul 2019 11:36:10 -0400
Date: Mon, 1 Jul 2019 08:35:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Adding some trees to linux-next?
Message-ID: <20190701153552.GJ1404256@magnolia>
References: <20190701110603.5abcbb2c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701110603.5abcbb2c@canb.auug.org.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-xfs@vger.kernel.org, Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi Stephen,

Could you add my iomap-for-next and vfs-for-next branches to linux-next,
please?  They can be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#iomap-for-next
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git#vfs-for-next

I've decided that trying to munge all that through the xfs for-next
branch is too much insanity and splitting them up will help me prevent
my head from falling off.

--Darrick
