Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433AEC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 22:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC98B64FAE
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 22:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBDW1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Feb 2021 17:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhBDW1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Feb 2021 17:27:49 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21224C0613D6
        for <linux-xfs@vger.kernel.org>; Thu,  4 Feb 2021 14:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=C6hbzntBnwy0FWvdJXFyLzMRNyCEuNeOYU8tLZC/AQA=; b=htIPv7eeIz2GdBMuvu9Q/qxgJm
        TEOeqrUunHEqSxtrca8rugCdD5LrsG11K/dktfRMHOOkW+DnXodq+1gmztNo6D8qJp9KiDkciuxOy
        CY9+4DPCdeOLWGMmd1VZgHO6egn/Wb6uo2fFjYPBPLj1GP6D9u9MtsMAWF8ipmMda3kj+5fgrsyKr
        FlGwUW9a+FYS++XJK2+wGkJui/d2ZxK0GfVJvLiW593IkqduMZavhyhlBIbEobsWvPzAVBnS6pbpR
        SNOg1qQ3IAP66qwVuEGsi7V2V0OVXzNTi+uNjUgk5IcaHHzOs7ZskrnYR+n3KDJgwGHzqbuJY31hA
        SSX5V5sw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1l7n5f-00036D-CX; Thu, 04 Feb 2021 22:27:07 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Bastian Germann <bastiangermann@fishpost.de>
CC:     debian-bugs-closed@lists.debian.org, linux-xfs@vger.kernel.org
Subject: Processed (with 6 errors): xfsprogs: categorize issues
Message-ID: <handler.s.C.161247743710530.transcript@bugs.debian.org>
References: <242c3aec-10b9-105d-c1e7-85d5ef00851b@fishpost.de>
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Source: xfsprogs
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 04 Feb 2021 22:27:07 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 484069 confirm
Unknown tag/s: confirm.
Recognized are: patch wontfix moreinfo unreproducible help security upstrea=
m pending confirmed ipv6 lfs d-i l10n newcomer a11y ftbfs fixed-upstream fi=
xed fixed-in-experimental sid experimental potato woody sarge sarge-ignore =
etch etch-ignore lenny lenny-ignore squeeze squeeze-ignore wheezy wheezy-ig=
nore jessie jessie-ignore stretch stretch-ignore buster buster-ignore bulls=
eye bullseye-ignore bookworm bookworm-ignore trixie trixie-ignore.

> tags 528356 confirm
Unknown tag/s: confirm.
Recognized are: patch wontfix moreinfo unreproducible help security upstrea=
m pending confirmed ipv6 lfs d-i l10n newcomer a11y ftbfs fixed-upstream fi=
xed fixed-in-experimental sid experimental potato woody sarge sarge-ignore =
etch etch-ignore lenny lenny-ignore squeeze squeeze-ignore wheezy wheezy-ig=
nore jessie jessie-ignore stretch stretch-ignore buster buster-ignore bulls=
eye bullseye-ignore bookworm bookworm-ignore trixie trixie-ignore.

> tags 570704 confirm
Unknown tag/s: confirm.
Recognized are: patch wontfix moreinfo unreproducible help security upstrea=
m pending confirmed ipv6 lfs d-i l10n newcomer a11y ftbfs fixed-upstream fi=
xed fixed-in-experimental sid experimental potato woody sarge sarge-ignore =
etch etch-ignore lenny lenny-ignore squeeze squeeze-ignore wheezy wheezy-ig=
nore jessie jessie-ignore stretch stretch-ignore buster buster-ignore bulls=
eye bullseye-ignore bookworm bookworm-ignore trixie trixie-ignore.

> tags 584256 moreinfo
Bug #584256 [xfsprogs] xfsprogs: xfs_repair -n segfaults after "This is a b=
ug"
Added tag(s) moreinfo.
> tags 915124 confirm
Unknown tag/s: confirm.
Recognized are: patch wontfix moreinfo unreproducible help security upstrea=
m pending confirmed ipv6 lfs d-i l10n newcomer a11y ftbfs fixed-upstream fi=
xed fixed-in-experimental sid experimental potato woody sarge sarge-ignore =
etch etch-ignore lenny lenny-ignore squeeze squeeze-ignore wheezy wheezy-ig=
nore jessie jessie-ignore stretch stretch-ignore buster buster-ignore bulls=
eye bullseye-ignore bookworm bookworm-ignore trixie trixie-ignore.

> tags 293275 confirm
Unknown tag/s: confirm.
Recognized are: patch wontfix moreinfo unreproducible help security upstrea=
m pending confirmed ipv6 lfs d-i l10n newcomer a11y ftbfs fixed-upstream fi=
xed fixed-in-experimental sid experimental potato woody sarge sarge-ignore =
etch etch-ignore lenny lenny-ignore squeeze squeeze-ignore wheezy wheezy-ig=
nore jessie jessie-ignore stretch stretch-ignore buster buster-ignore bulls=
eye bullseye-ignore bookworm bookworm-ignore trixie trixie-ignore.

> close 470706
Bug #470706 [xfsprogs] xfsprogs: xfs_repair crashes during attempted repair
Marked Bug as done
> close 598908 5.10.0-2
Bug #598908 [xfsprogs] xfs_growfs: -I is an option in the help but if used =
"Invalid Option" is returned
Marked as fixed in versions xfsprogs/5.10.0-2.
Bug #598908 [xfsprogs] xfs_growfs: -I is an option in the help but if used =
"Invalid Option" is returned
Marked Bug as done
> found 518637 5.10.0-2
Bug #518637 [xfsprogs] xfsprogs: xfs_admin -c1 fails with unhelpful error m=
essage
Marked as found in versions xfsprogs/5.10.0-2.
> tags 518637 confirm
Unknown tag/s: confirm.
Recognized are: patch wontfix moreinfo unreproducible help security upstrea=
m pending confirmed ipv6 lfs d-i l10n newcomer a11y ftbfs fixed-upstream fi=
xed fixed-in-experimental sid experimental potato woody sarge sarge-ignore =
etch etch-ignore lenny lenny-ignore squeeze squeeze-ignore wheezy wheezy-ig=
nore jessie jessie-ignore stretch stretch-ignore buster buster-ignore bulls=
eye bullseye-ignore bookworm bookworm-ignore trixie trixie-ignore.

> tags 695640 patch
Bug #695640 [xfsprogs] xfs_quota: cannot find mount point for path: Success
Added tag(s) patch.
> tags 807879 wontfix
Bug #807879 [xfsprogs] xfsprogs: Cannot mount XFS filesystem formated with =
mkfs.xfs newer than 3.2.1
Added tag(s) wontfix.
> tags 839129 moreinfo
Bug #839129 [xfsprogs] xfsprogs: xfs_fsr XFS_IOC_SWAPEXT failed: ino=3D[xxx=
xxxx]: Invalid argument
Added tag(s) moreinfo.
>
End of message, stopping processing here.

Please contact me if you need assistance.
--=20
470706: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D470706
518637: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D518637
584256: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D584256
598908: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D598908
695640: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D695640
807879: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D807879
839129: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D839129
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
