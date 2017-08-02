Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751162AbdHBJYV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 05:24:21 -0400
Date: Wed, 2 Aug 2017 11:24:16 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2 4/7] xfs_db: dump dir/attr btrees
Message-ID: <20170802092416.md6vsrkplsqwnueq@hades.localdomain>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153523353.26081.1989249017494623271.stgit@magnolia>
 <20170801154053.GH4477@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170801154053.GH4477@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Tue, Aug 01, 2017 at 08:40:53AM -0700, Darrick J. Wong wrote:
> Dump the directory or extended attribute btree contents.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Btw, this is missing a changelog comparing with the V1, but I believe it doesn't
go to the patch description anyway.


-- 
Carlos
