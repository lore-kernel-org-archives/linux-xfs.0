Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030259AbeFSU7o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 16:59:44 -0400
Date: Tue, 19 Jun 2018 22:59:42 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH] mkfs: removed unused dft var from open_config_file
Message-ID: <20180619205942.GZ5527@wotan.suse.de>
References: <b437d75c-7226-19bc-c709-9b706ef853eb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b437d75c-7226-19bc-c709-9b706ef853eb@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>

On Tue, Jun 19, 2018 at 03:07:01PM -0500, Eric Sandeen wrote:
> This should have been removed when I removed the dft->type
> tracking.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@kernel.org>

  Luis
