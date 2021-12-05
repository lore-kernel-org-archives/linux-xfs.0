Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004A6C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Dec 2021 15:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhLEQAk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Dec 2021 11:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbhLEQAj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Dec 2021 11:00:39 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DBCC061751
        for <linux-xfs@vger.kernel.org>; Sun,  5 Dec 2021 07:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=s92JIsqE7tK9oqfvEvF7lLW7fk9RSEo//s62g3OtueY=; b=oIwfmTxhpNjq5ipuavHWUQslwx
        /jioSO6YPoOV9mzu4q/N3KQ9LJjqZz2yuZwJnvlyESvMTepCc2MO7XYyOEnwRvx+1ozoGWt6aoDGE
        y1MCiSsqcqld9QXUjv6iYW4a4xUsTofTujt6ar+LprpKMXf9Iy5kDlpQwlZWJqiH51KJoxgr+14gT
        NjCEX2cX7Lj2n4Gep3rSPqWN2k8xd8iTHmMx9PCVDmJgfzyrWto11aq8KzrY/TENbSwixwia3B18L
        7fWQoetGDw+GhSqZObkkaHS2/N2K0wnjVHHqhHPAwBsAl9+GHsyfVm+fD1yeMpx/3IImSnNmiWPEg
        pnD2cihw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1mttsx-0000j2-Vo; Sun, 05 Dec 2021 15:57:07 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Giovanni Mascellani <gio@debian.org>
CC:     linux-xfs@vger.kernel.org, team+boost@tracker.debian.org
Subject: Processed (with 1 error): Re: Bug#1000974: copy_move_algo.hpp:1083:10:
 error: =?UTF-8?Q?=E2=80=98=5F=5Ffallthrough=5F=5F=E2=80=99?= was not
 declared in this scope; did you mean =?UTF-8?Q?=E2=80=98fallthrough=E2=80=99=3F?=
Message-ID: <handler.s.C.16387197672501.transcript@bugs.debian.org>
References: <c7ccff50-c177-7f96-2d99-2077f77374ad@debian.org>
X-Debian-PR-Package: libboost1.74-dev xfslibs-dev
X-Debian-PR-Source: boost1.74 xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Sun, 05 Dec 2021 15:57:07 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> reassign 1000974 xfslibs-dev
Bug #1000974 [libboost1.74-dev] copy_move_algo.hpp:1083:10: error: =E2=80=
=98__fallthrough__=E2=80=99 was not declared in this scope; did you mean =
=E2=80=98fallthrough=E2=80=99?
Bug reassigned from package 'libboost1.74-dev' to 'xfslibs-dev'.
No longer marked as found in versions boost1.74/1.74.0-13.
Ignoring request to alter fixed versions of bug #1000974 to the same values=
 previously set
> severity 1000974 important
Bug #1000974 [xfslibs-dev] copy_move_algo.hpp:1083:10: error: =E2=80=98__fa=
llthrough__=E2=80=99 was not declared in this scope; did you mean =E2=80=98=
fallthrough=E2=80=99?
Ignoring request to change severity of Bug 1000974 to the same value.
> retitle 1000974 xfs/linux.h defines common word "fallthrough" breaking
Bug #1000974 [xfslibs-dev] copy_move_algo.hpp:1083:10: error: =E2=80=98__fa=
llthrough__=E2=80=99 was not declared in this scope; did you mean =E2=80=98=
fallthrough=E2=80=99?
Changed Bug title to 'xfs/linux.h defines common word "fallthrough" breakin=
g' from 'copy_move_algo.hpp:1083:10: error: =E2=80=98__fallthrough__=E2=80=
=99 was not declared in this scope; did you mean =E2=80=98fallthrough=E2=80=
=99?'.
> unrelated headers
Unknown command or malformed arguments to command.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1000974: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1000974
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
