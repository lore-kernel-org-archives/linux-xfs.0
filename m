Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50630 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdHBQDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2017 12:03:22 -0400
Date: Wed, 2 Aug 2017 09:03:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/7] xfs_db: dump dir/attr btrees
Message-ID: <20170802160317.GN4477@magnolia>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153523353.26081.1989249017494623271.stgit@magnolia>
 <20170801154053.GH4477@magnolia>
 <20170802092416.md6vsrkplsqwnueq@hades.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802092416.md6vsrkplsqwnueq@hades.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Wed, Aug 02, 2017 at 11:24:16AM +0200, Carlos Maiolino wrote:
> On Tue, Aug 01, 2017 at 08:40:53AM -0700, Darrick J. Wong wrote:
> > Dump the directory or extended attribute btree contents.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Btw, this is missing a changelog comparing with the V1, but I believe it doesn't
> go to the patch description anyway.

---
v2: fix whitespace problems, rename ops struct to have _ops in name, amend
help screen to say that we can dump dir/attr btrees now.
---

--D

> 
> 
> -- 
> Carlos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
