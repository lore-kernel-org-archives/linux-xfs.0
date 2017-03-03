Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52775 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752178AbdCDACm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 19:02:42 -0500
Date: Sat, 4 Mar 2017 00:24:59 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 0/9] mkfs.xfs: add mkfs.xfs.conf support
Message-ID: <20170303232459.GA14437@wotan.suse.de>
References: <20170303231316.12716-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com

On Fri, Mar 03, 2017 at 03:13:07PM -0800, Luis R. Rodriguez wrote:
> This has been based on top of xfsprogs-dev v4.9.0-rc1.

Actually originally it was, I rebased onto the latest on git master which seems
to be the v4.10.0 release, these patches are based on that.

I do have patches which apply to v4.9.0 if anyone is interested they are here:

http://drvbp1.linux-foundation.org/~mcgrof/patches/2017/03/03/20170303-conf-v4.9.0-rc1/

  Luis
