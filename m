Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43388 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdFZIFb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Jun 2017 04:05:31 -0400
Date: Mon, 26 Jun 2017 10:05:26 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v7 01/22] fs: remove call_fsync helper function
Message-ID: <20170626080526.ufetu6blf2kllihn@eorzea.usersys.redhat.com>
References: <20170616193427.13955-1-jlayton@redhat.com>
 <20170616193427.13955-2-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170616193427.13955-2-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org

On Fri, Jun 16, 2017 at 03:34:06PM -0400, Jeff Layton wrote:
> Requested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/sync.c          | 2 +-
>  include/linux/fs.h | 6 ------
>  ipc/shm.c          | 2 +-
>  3 files changed, 2 insertions(+), 8 deletions(-)
> 
> 2.13.0
If it's worth to have one more reviewer, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 

-- 
Carlos
