Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbeJSFIX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Oct 2018 01:08:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
References: <20181002100531.GC4135@quack2.suse.cz>
        <20181002121039.GA3274@linux-x5ow.site>
        <20181002142959.GD9127@quack2.suse.cz>
        <x49h8hkfhk9.fsf@segfault.boston.devel.redhat.com>
        <20181018002510.GC6311@dastard>
Date: Thu, 18 Oct 2018 17:05:30 -0400
In-Reply-To: <20181018002510.GC6311@dastard> (Dave Chinner's message of "Thu,
        18 Oct 2018 11:25:10 +1100")
Message-ID: <x49woqfq82t.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org

Dave,

Thanks for the detailed response!  I hadn't considered the NOVA use case
at all.

Cheers,
Jeff
