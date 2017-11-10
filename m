Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755783AbdKJDcO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 22:32:14 -0500
Date: Fri, 10 Nov 2017 11:32:09 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/4] xfs: test that we don't leak inodes and dquots
 during failed cow recovery
Message-ID: <20171110033209.GZ17339@eguan.usersys.redhat.com>
References: <151027466195.13147.10381301768189156101.stgit@magnolia>
 <151027468041.13147.97625419607665689.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151027468041.13147.97625419607665689.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Nov 09, 2017 at 04:44:40PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a couple of tests to check that we don't leak inodes or dquots
> if CoW recovery fails and therefore the mount fails.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I thought I've picked them up in last update.. Will queue them in now.

Thanks,
Eryu
