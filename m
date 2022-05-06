Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E91C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 10:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390968AbiEFK23 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 06:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390953AbiEFK22 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 06:28:28 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1591863BF4
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 03:24:46 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:52536)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1nmv8f-002q09-UC
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 10:24:44 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=6SQHr02vHDZYsa2Cun3TR079/Q9WHT7fmv/dv4KU4Zk=; b=jSc06jz5SpQ++PpCce2Ly7mAB/
        yeSYNHCu/ZtYA5kBzMUOx19qkpKGiYYnhd2HJ746Sf3Dpxv+srE4CFJbvUth0PlCCbUyMX1Bapg/M
        pVFRtycvGzaawiraqdncu1j1tL5WFvOWA8jhPffjy91ALOEUwyMkvKVPgF7thBYEjI+b+SnuJEVdL
        8qhLLVKw9Z4QyboR8lwfwJaVuas4vdsase8QlDXvj0fE3SI6Jh2BEy8EI5RTlB/q+mTktNuUl1VCr
        DaLXNWZy9z/vSuoo4oLBxsl5yBeenaVwgSOXYDjs+RIAqC4fRjRsOKPmO3UY/KKtbOgoJPaGfiXzw
        K7uoldIg==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.92)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1nmv8c-0007wi-VL
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 10:24:42 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_5.16.0-1_source.changes
Date:   Fri, 06 May 2022 10:24:42 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1nmv8c-0007wi-VL@usper.debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

/xfsprogs_5.16.0-1_source.changes is already present on target host:
xfsprogs_5.16.0-1_source.buildinfo
Either you already uploaded it, or someone else came first.
Job xfsprogs_5.16.0-1_source.changes removed.

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
