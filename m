Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58762 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948756AbdEZVr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 May 2017 17:47:58 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: RFC: removing non-linux platform support from xfsprogs
Message-ID: <7d962368-5376-0fca-dbc6-3d3f6fdf50e8@sandeen.net>
Date: Fri, 26 May 2017 16:47:57 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>

There's a bunch of mucking about to try to build xfsprogs on non-linux
platforms.  Is anyone using that, or care about it?  If not, I propose
removing it all in a cruft-reducing effort.

If I'm missing some good reason for it to be there, please educate me,
and I'll leave it alone.

In particular, Jan - I know you did a lot of this work - do you still
use it?

Thanks,
-Eric

