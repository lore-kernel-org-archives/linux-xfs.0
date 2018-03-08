Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:38023 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbeCHNXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Mar 2018 08:23:42 -0500
Received: by mail-wr0-f170.google.com with SMTP id n7so5666786wrn.5
        for <linux-xfs@vger.kernel.org>; Thu, 08 Mar 2018 05:23:42 -0800 (PST)
Date: Thu, 8 Mar 2018 14:23:37 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 4/4] Get rid of XFS_BUF_SET_COUNT() macro
Message-ID: <20180308132337.e6hpm2mn2vosjqjp@odin.usersys.redhat.com>
References: <20180306130053.13958-1-cmaiolino@redhat.com>
 <20180306130053.13958-5-cmaiolino@redhat.com>
 <20180308081615.GK15163@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180308081615.GK15163@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Mar 08, 2018 at 12:16:15AM -0800, Christoph Hellwig wrote:
> Looks good, although it conflicts with Erics patches..

Thanks, I didn't try to rebase it over Eric's patches before sending it, I can
do a rebase over his patches and send the new version quickly. At least as soon
as we define if we should use the castings or not :)


> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
