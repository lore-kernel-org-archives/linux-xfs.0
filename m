Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:35684 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727623AbeKAAlj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 20:41:39 -0400
Received: by mail-wr1-f53.google.com with SMTP id w5-v6so17030607wrt.2
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 08:43:06 -0700 (PDT)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 31 Oct 2018 16:42:54 +0100
Message-ID: <CACj3i70vGdyPVytPV_mpF5TnPX9q8jr=1td=1xm3KsW7_jEFwA@mail.gmail.com>
Subject: xfsdump usecases
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Zirong Lang <zlang@redhat.com>

Hi guys

I'm doing some cleanup of xfsdump code and the testing infrastructure
for it in xfstests is rather small, for the number of options and
modes xfsdump has. So, I'm asking you if you have any scripts using
xfsdump and xfsrestore, or some custom test suite, can you share it? I
will polish it and put into xfstests.


Thanks,
Jan
