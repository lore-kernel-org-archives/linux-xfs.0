Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbeKACdM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Oct 2018 22:33:12 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D701130917AF
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 17:34:14 +0000 (UTC)
Date: Thu, 1 Nov 2018 01:35:49 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: xfsdump usecases
Message-ID: <20181031173549.GI2279@dhcp-12-117.nay.redhat.com>
References: <CACj3i70vGdyPVytPV_mpF5TnPX9q8jr=1td=1xm3KsW7_jEFwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i70vGdyPVytPV_mpF5TnPX9q8jr=1td=1xm3KsW7_jEFwA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 04:42:54PM +0100, Jan Tulak wrote:
> Hi guys
> 
> I'm doing some cleanup of xfsdump code and the testing infrastructure
> for it in xfstests is rather small, for the number of options and
> modes xfsdump has. So, I'm asking you if you have any scripts using
> xfsdump and xfsrestore, or some custom test suite, can you share it? I
> will polish it and put into xfstests.

Hi Jan,

Unfortunately, we don't have more internal test cases (than xfstests) about
xfsdump/xfsrestore. There's not much bugs(from customers/partners) about
xfsdump, and it keeps stable(no big changes) long time, so writing cases for
it always be low priority jobs for us.

I can help to write some cases or do some tests if you need.

Thanks,
Zorro

> 
> 
> Thanks,
> Jan
