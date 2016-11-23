Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60420 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934889AbcKWJ7L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Nov 2016 04:59:11 -0500
Date: Wed, 23 Nov 2016 17:59:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 2/3] misc: fix some minor problems testing ocfs2
Message-ID: <20161123095909.GF12442@eguan.usersys.redhat.com>
References: <147986705412.27133.3961713804630246198.stgit@birch.djwong.org>
 <147986706035.27133.12508201579910106497.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147986706035.27133.12508201579910106497.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Nov 22, 2016 at 06:11:00PM -0800, Darrick J. Wong wrote:
> There are a a few things about ocfs2 tools that need special-casing in
> xfstests, so fix them so that we can start testing ocfs2.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This is in my last pull request to Dave, just not upstream yet (if
everything works well :-).

Thanks,
Eryu
