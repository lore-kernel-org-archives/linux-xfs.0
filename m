Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752410AbdK1Tkr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:40:47 -0500
Date: Tue, 28 Nov 2017 20:40:45 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
Message-ID: <20171128194045.2oi3f4a63urq4l2l@dhcp22.suse.cz>
References: <20171123120828.31881-1-mhocko@kernel.org>
 <20171123132633.GB21798@infradead.org>
 <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
 <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
 <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <20171123220045.GV5858@dastard>
 <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
 <20171127174453.GC19379@magnolia>
 <20171128093551.mjwao7afv75me6ht@dhcp22.suse.cz>
 <20171128163919.GH21412@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128163919.GH21412@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, hch@infradead.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 28-11-17 08:39:19, Darrick J. Wong wrote:
> On Tue, Nov 28, 2017 at 10:35:51AM +0100, Michal Hocko wrote:
[...]
> > Are you going to apply the patch or should I re-send it with
> > acks/reviewed-by?
> 
> I injected all of those when I added the patch to my tree:
> 
> Noticed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!
-- 
Michal Hocko
SUSE Labs
