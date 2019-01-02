Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43387 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728120AbfABMU1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 07:20:27 -0500
Received: by mail-wr1-f52.google.com with SMTP id r10so30273116wrs.10
        for <linux-xfs@vger.kernel.org>; Wed, 02 Jan 2019 04:20:27 -0800 (PST)
Date: Wed, 2 Jan 2019 13:20:24 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: upgrade V4 to V5?
Message-ID: <20190102122024.dup5cct5p4vnkgr6@hades.usersys.redhat.com>
References: <b97c91a2-fbd1-dbbc-e797-5f9cec7bc01f@nord-west.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b97c91a2-fbd1-dbbc-e797-5f9cec7bc01f@nord-west.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bjoern Franke <bjo@nord-west.org>
Cc: linux-xfs@vger.kernel.org

Hi.

On Wed, Jan 02, 2019 at 12:34:42PM +0100, Bjoern Franke wrote:
> Hi,
> 
> is is possible to upgrade a V4 XFS to V5 without reformatting, e.g. with
> xfs_db or xfs_admin?

No, it is not, you will need to re-format the filesystem.

Cheers.

> 
> Kind regards
> Bjoern

-- 
Carlos
