Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58D4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 10:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390871AbiEFKX3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 06:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiEFKX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 06:23:29 -0400
Received: from mailly.debian.org (mailly.debian.org [IPv6:2001:41b8:202:deb:6564:a62:52c3:4b72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19645DE54
        for <linux-xfs@vger.kernel.org>; Fri,  6 May 2022 03:19:46 -0700 (PDT)
Received: from usper.debian.org ([2603:400a:ffff:bb8::801f:45]:52528)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=usper.debian.org,EMAIL=hostmaster@usper.debian.org (verified)
        by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1nmv3o-002pkx-Oy
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 10:19:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ftp-master.debian.org; s=smtpauto.usper; h=Message-Id:Date:Subject:From:To:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=c3BPkykL+EK8dGO6zTwfmAhacXUSFcFIhSARdQlyR1U=; b=Dk0u/a2r9ideT5ETZObvH0MkiI
        C6VL58KFkW5vzlSDfpU5kzLmnjZId4v/hyIKdrcKOpjA7+BHrenjYV+MqKQd+K1MrLvyEvIl33bM+
        QQunkZXX2xLpkZaCLyZWIqkvb3PycW8J0SL2Co5xYYQlHV79PLumUosRnzfPcdN1hSirFwLCprMH5
        +H5zXYL3pTlYvP3bbDIBuKC16p2KYQso+9kImwMu2ND0md8B6iipMf3+Ki1zFfuoQ7HNcbcRDPoCW
        bm6Gq3XgaHsCMoNhlD5zvRLZ3v6I8DRgf4O0jciLJuPpAyjHlP+7kFFA4hSvr2nTUc6Bai4Z943IM
        8CZEqpMQ==;
Received: from dak-unpriv by usper.debian.org with local (Exim 4.92)
        (envelope-from <ftpmaster@ftp-master.debian.org>)
        id 1nmv3m-0007hM-DS
        for linux-xfs@vger.kernel.org; Fri, 06 May 2022 10:19:42 +0000
To:     linux-xfs@vger.kernel.org
From:   Debian FTP Masters <ftpmaster@ftp-master.debian.org>
Subject: Processing of xfsprogs_5.16.0-1_source.changes
Date:   Fri, 06 May 2022 10:19:42 +0000
X-Debian: DAK
X-DAK:  DAK
Auto-Submitted: auto-generated
X-Debian-Package: xfsprogs
Message-Id: <E1nmv3m-0007hM-DS@usper.debian.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfsprogs_5.16.0-1_source.changes uploaded successfully to localhost
along with the files:
  xfsprogs_5.16.0-1.dsc
  xfsprogs_5.16.0.orig.tar.xz
  xfsprogs_5.16.0-1.debian.tar.xz
  xfsprogs_5.16.0-1_source.buildinfo

Greetings,

	Your Debian queue daemon (running on host usper.debian.org)
